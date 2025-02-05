import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static targets = ["responseList", "chart"]

  connect() {
    this.initializeCharts()
  }

  toggleResponses(event) {
    const index = event.currentTarget.dataset.questionIndex
    const responseList = this.responseListTargets.find(el => el.dataset.questionIndex === index)
    const isHidden = responseList.classList.contains('hidden')
    
    responseList.classList.toggle('hidden')
    event.currentTarget.textContent = isHidden ? 'Ocultar respostas' : 'Mostrar todas as respostas'
  }

  initializeCharts() {
    this.chartTargets.forEach(canvas => {
      const type = canvas.dataset.type
      const questionIndex = canvas.dataset.questionIndex

      if (type === 'number') {
        const values = JSON.parse(canvas.dataset.values)
        new Chart(canvas, {
          type: 'bar',
          data: {
            labels: this.generateHistogramLabels(values),
            datasets: [{
              label: 'Distribuição das Respostas',
              data: this.generateHistogramData(values),
              backgroundColor: 'rgba(79, 70, 229, 0.5)',
              borderColor: 'rgb(79, 70, 229)',
              borderWidth: 1
            }]
          },
          options: {
            responsive: true,
            scales: {
              y: {
                beginAtZero: true,
                ticks: {
                  stepSize: 1
                }
              }
            },
            plugins: {
              legend: {
                display: false
              },
              tooltip: {
                callbacks: {
                  title: (items) => {
                    const item = items[0]
                    const bin = this.histogramBins[item.dataIndex]
                    return `${bin.min.toFixed(1)} - ${bin.max.toFixed(1)}`
                  }
                }
              }
            }
          }
        })
      } else if (type === 'multiple_choice') {
        const options = JSON.parse(canvas.dataset.options)
        const values = JSON.parse(canvas.dataset.values)
        const data = options.map(option => values.filter(v => v === option).length)

        new Chart(canvas, {
          type: 'doughnut',
          data: {
            labels: options,
            datasets: [{
              data: data,
              backgroundColor: [
                'rgba(79, 70, 229, 0.5)',
                'rgba(16, 185, 129, 0.5)',
                'rgba(245, 158, 11, 0.5)',
                'rgba(239, 68, 68, 0.5)',
                'rgba(107, 114, 128, 0.5)'
              ]
            }]
          },
          options: {
            responsive: true,
            plugins: {
              legend: {
                position: 'bottom'
              }
            }
          }
        })
      }
    })
  }

  generateHistogramBins(values) {
    const min = Math.min(...values)
    const max = Math.max(...values)
    const binCount = Math.min(10, Math.ceil(Math.sqrt(values.length)))
    const binSize = (max - min) / binCount
    
    const bins = []
    for (let i = 0; i < binCount; i++) {
      bins.push({
        min: min + (i * binSize),
        max: min + ((i + 1) * binSize),
        count: 0
      })
    }

    values.forEach(value => {
      const bin = bins.find(bin => value >= bin.min && value < bin.max)
      if (bin) bin.count++
    })

    this.histogramBins = bins
    return bins
  }

  generateHistogramLabels(values) {
    const bins = this.generateHistogramBins(values)
    return bins.map(bin => `${bin.min.toFixed(1)}-${bin.max.toFixed(1)}`)
  }

  generateHistogramData(values) {
    return this.histogramBins.map(bin => bin.count)
  }
} 